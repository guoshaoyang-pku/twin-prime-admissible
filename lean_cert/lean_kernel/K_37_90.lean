import Sound
import lean_certs.cert_37_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_90_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 37) (d := 90) (c := cert_37_90) (by decide)
