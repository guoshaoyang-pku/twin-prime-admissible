import Sound
import lean_certs.cert_49_230

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_230_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 230 := by
  exact certValidRoot_sound (k := 49) (d := 230) (c := cert_49_230) (by decide)
