import Sound
import lean_certs.cert_27_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_94_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 27) (d := 94) (c := cert_27_94) (by decide)
