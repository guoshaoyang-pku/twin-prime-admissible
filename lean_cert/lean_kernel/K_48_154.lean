import Sound
import lean_certs.cert_48_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_154_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 48) (d := 154) (c := cert_48_154) (by decide)
