import Sound
import lean_certs.cert_14_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H14_gt_46_kernel : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 14) (d := 46) (c := cert_14_46) (by decide)
