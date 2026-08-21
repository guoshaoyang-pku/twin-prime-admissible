import Sound
import lean_certs.cert_50_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_142_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 50) (d := 142) (c := cert_50_142) (by decide)
