import Sound
import lean_certs.cert_35_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_142_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 35) (d := 142) (c := cert_35_142) (by decide)
