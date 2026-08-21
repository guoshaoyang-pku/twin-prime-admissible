import Sound
import lean_certs.cert_27_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_52_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 27) (d := 52) (c := cert_27_52) (by decide)
