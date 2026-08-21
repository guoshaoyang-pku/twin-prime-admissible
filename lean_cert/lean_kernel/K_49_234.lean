import Sound
import lean_certs.cert_49_234

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_234_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 234 := by
  exact certValidRoot_sound (k := 49) (d := 234) (c := cert_49_234) (by decide)
