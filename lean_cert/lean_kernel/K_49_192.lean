import Sound
import lean_certs.cert_49_192

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_192_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 49) (d := 192) (c := cert_49_192) (by decide)
