import Sound
import lean_certs.cert_49_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_154_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 49) (d := 154) (c := cert_49_154) (by decide)
