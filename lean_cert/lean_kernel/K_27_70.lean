import Sound
import lean_certs.cert_27_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_70_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 27) (d := 70) (c := cert_27_70) (by decide)
