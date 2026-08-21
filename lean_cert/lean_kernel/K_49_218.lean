import Sound
import lean_certs.cert_49_218

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_218_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 218 := by
  exact certValidRoot_sound (k := 49) (d := 218) (c := cert_49_218) (by decide)
