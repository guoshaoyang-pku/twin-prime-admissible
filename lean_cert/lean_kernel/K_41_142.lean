import Sound
import lean_certs.cert_41_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_142_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 41) (d := 142) (c := cert_41_142) (by decide)
