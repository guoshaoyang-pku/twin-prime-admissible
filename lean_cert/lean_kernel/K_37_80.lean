import Sound
import lean_certs.cert_37_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_80_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 37) (d := 80) (c := cert_37_80) (by decide)
