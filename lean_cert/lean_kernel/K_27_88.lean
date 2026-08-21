import Sound
import lean_certs.cert_27_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_88_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 27) (d := 88) (c := cert_27_88) (by decide)
