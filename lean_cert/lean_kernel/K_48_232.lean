import Sound
import lean_certs.cert_48_232

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H48_gt_232_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 232 := by
  exact certValidRoot_sound (k := 48) (d := 232) (c := cert_48_232) (by decide)
