import Sound
import lean_certs.cert_24_68

open CertVerify

theorem H24_gt_68 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 24) (d := 68) (c := cert_24_68) (by native_decide)
