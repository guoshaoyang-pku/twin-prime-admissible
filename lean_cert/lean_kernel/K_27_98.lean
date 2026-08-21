import Sound
import lean_certs.cert_27_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_98_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 27) (d := 98) (c := cert_27_98) (by decide)
