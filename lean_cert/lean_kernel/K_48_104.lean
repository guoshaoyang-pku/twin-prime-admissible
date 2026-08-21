import Sound
import lean_certs.cert_48_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_104_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 48) (d := 104) (c := cert_48_104) (by decide)
