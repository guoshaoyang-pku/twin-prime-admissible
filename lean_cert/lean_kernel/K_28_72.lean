import Sound
import lean_certs.cert_28_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_72_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 28) (d := 72) (c := cert_28_72) (by decide)
