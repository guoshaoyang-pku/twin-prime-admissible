import Sound
import lean_certs.cert_27_54

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_54_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 27) (d := 54) (c := cert_27_54) (by decide)
