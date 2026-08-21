import Sound
import lean_certs.cert_19_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_72_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 19) (d := 72) (c := cert_19_72) (by decide)
