import Sound
import lean_certs.cert_26_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_86_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 26) (d := 86) (c := cert_26_86) (by decide)
