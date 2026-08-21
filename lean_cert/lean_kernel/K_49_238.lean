import Sound
import lean_certs.cert_49_238

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_238_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 238 := by
  exact certValidRoot_sound (k := 49) (d := 238) (c := cert_49_238) (by decide)
