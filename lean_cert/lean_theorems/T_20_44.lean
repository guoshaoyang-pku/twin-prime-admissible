import Sound
import lean_certs.cert_20_44

open CertVerify

theorem H20_gt_44 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 20) (d := 44) (c := cert_20_44) (by native_decide)
