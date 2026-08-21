import Sound
import lean_certs.cert_20_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_72_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 20) (d := 72) (c := cert_20_72) (by decide)
