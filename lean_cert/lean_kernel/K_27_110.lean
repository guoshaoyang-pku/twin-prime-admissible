import Sound
import lean_certs.cert_27_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_110_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 27) (d := 110) (c := cert_27_110) (by decide)
