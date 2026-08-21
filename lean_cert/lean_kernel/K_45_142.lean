import Sound
import lean_certs.cert_45_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_142_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 45) (d := 142) (c := cert_45_142) (by decide)
