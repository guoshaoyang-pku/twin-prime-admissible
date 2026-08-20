import Sound
import lean_certs.cert_37_144

open CertVerify

theorem H37_gt_144 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 37) (d := 144) (c := cert_37_144) (by native_decide)
