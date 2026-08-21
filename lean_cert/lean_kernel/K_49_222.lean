import Sound
import lean_certs.cert_49_222

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_222_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 222 := by
  exact certValidRoot_sound (k := 49) (d := 222) (c := cert_49_222) (by decide)
