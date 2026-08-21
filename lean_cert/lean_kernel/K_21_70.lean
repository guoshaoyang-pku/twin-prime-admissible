import Sound
import lean_certs.cert_21_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_70_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 21) (d := 70) (c := cert_21_70) (by decide)
