import Sound
import lean_certs.cert_37_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_86_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 37) (d := 86) (c := cert_37_86) (by decide)
