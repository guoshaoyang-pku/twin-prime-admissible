import Sound
import lean_certs.cert_47_214

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_214_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 214 := by
  exact certValidRoot_sound (k := 47) (d := 214) (c := cert_47_214) (by decide)
