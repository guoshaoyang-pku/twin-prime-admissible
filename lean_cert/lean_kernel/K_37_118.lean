import Sound
import lean_certs.cert_37_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_118_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 37) (d := 118) (c := cert_37_118) (by decide)
