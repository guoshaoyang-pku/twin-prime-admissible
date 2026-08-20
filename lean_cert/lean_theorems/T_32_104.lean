import Sound
import lean_certs.cert_32_104

open CertVerify

theorem H32_gt_104 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 32) (d := 104) (c := cert_32_104) (by native_decide)
