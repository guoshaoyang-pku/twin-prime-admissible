import Sound
import lean_certs.cert_22_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_46_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 22) (d := 46) (c := cert_22_46) (by decide)
