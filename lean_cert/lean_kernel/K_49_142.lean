import Sound
import lean_certs.cert_49_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_142_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 49) (d := 142) (c := cert_49_142) (by decide)
