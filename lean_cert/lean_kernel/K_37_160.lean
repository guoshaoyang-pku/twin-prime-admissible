import Sound
import lean_certs.cert_37_160

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H37_gt_160_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 37) (d := 160) (c := cert_37_160) (by decide)
