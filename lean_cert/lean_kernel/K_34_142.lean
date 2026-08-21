import Sound
import lean_certs.cert_34_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_142_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 34) (d := 142) (c := cert_34_142) (by decide)
