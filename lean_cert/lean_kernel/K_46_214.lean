import Sound
import lean_certs.cert_46_214

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H46_gt_214_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 214 := by
  exact certValidRoot_sound (k := 46) (d := 214) (c := cert_46_214) (by decide)
