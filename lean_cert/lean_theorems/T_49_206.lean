import Sound
import lean_certs.cert_49_206

open CertVerify

theorem H49_gt_206 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 49) (d := 206) (c := cert_49_206) (by native_decide)
