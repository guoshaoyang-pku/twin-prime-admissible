import Sound
import lean_certs.cert_30_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_72_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 30) (d := 72) (c := cert_30_72) (by decide)
