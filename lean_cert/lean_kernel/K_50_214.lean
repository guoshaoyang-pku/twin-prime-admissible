import Sound
import lean_certs.cert_50_214

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_214_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 214 := by
  exact certValidRoot_sound (k := 50) (d := 214) (c := cert_50_214) (by decide)
