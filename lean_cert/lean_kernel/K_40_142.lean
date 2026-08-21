import Sound
import lean_certs.cert_40_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_142_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 40) (d := 142) (c := cert_40_142) (by decide)
