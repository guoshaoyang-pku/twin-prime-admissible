import Sound
import lean_certs.cert_26_68

open CertVerify

theorem H26_gt_68 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 26) (d := 68) (c := cert_26_68) (by native_decide)
