import Sound
import lean_certs.cert_21_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_46_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 21) (d := 46) (c := cert_21_46) (by decide)
