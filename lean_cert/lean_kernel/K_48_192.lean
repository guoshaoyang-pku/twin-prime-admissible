import Sound
import lean_certs.cert_48_192

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_192_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 48) (d := 192) (c := cert_48_192) (by decide)
