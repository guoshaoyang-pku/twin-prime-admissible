import Sound
import lean_certs.cert_46_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_142_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 46) (d := 142) (c := cert_46_142) (by decide)
