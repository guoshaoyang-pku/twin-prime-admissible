import Sound
import lean_certs.cert_48_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_142_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 48) (d := 142) (c := cert_48_142) (by decide)
