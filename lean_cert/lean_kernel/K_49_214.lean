import Sound
import lean_certs.cert_49_214

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_214_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 214 := by
  exact certValidRoot_sound (k := 49) (d := 214) (c := cert_49_214) (by decide)
