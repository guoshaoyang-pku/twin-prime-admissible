import Sound
import lean_certs.cert_49_232

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_232_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 232 := by
  exact certValidRoot_sound (k := 49) (d := 232) (c := cert_49_232) (by decide)
