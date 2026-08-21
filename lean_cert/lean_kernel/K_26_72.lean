import Sound
import lean_certs.cert_26_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_72_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 26) (d := 72) (c := cert_26_72) (by decide)
