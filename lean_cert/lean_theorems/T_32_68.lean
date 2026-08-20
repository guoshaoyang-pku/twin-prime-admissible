import Sound
import lean_certs.cert_32_68

open CertVerify

theorem H32_gt_68 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 32) (d := 68) (c := cert_32_68) (by native_decide)
