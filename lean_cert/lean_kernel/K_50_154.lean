import Sound
import lean_certs.cert_50_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_154_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 50) (d := 154) (c := cert_50_154) (by decide)
