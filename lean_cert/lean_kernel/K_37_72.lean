import Sound
import lean_certs.cert_37_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_72_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 37) (d := 72) (c := cert_37_72) (by decide)
